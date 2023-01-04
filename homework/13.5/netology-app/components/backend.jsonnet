local p = import '../params.libsonnet';
local db = p.db;
local backend = p.backend;
local images = p.images;

local r_name = p.release;
local r_namespace = std.extVar("qbec.io/env");
local r_chart = p.chart;

local db_port = std.get(db, "port_ext", default=db.port);
local backend_port = if std.objectHas(backend, "port_ext") then backend.port_ext else backend.port;

[
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      labels: {
        app: r_name + "-backend"
      },
      name: r_name + "-backend",
      namespace: r_namespace
    },
    spec: {
      replicas: std.get(backend, "replicas", default=1),
      selector: {
        matchLabels: {
          app: r_name + "-backend"
        }
      },
      template: {
        metadata: {
          labels: {
            app: r_name + "-backend"
          },
        },
        spec: {
          containers: [
            {
              name: r_chart + "-backend",
              image: images.backend + ":" + backend.image_tag,
              imagePullPolicy: images.pullPolicy,
              env: [
                {
                  name: "PG_ACC_LG",
                  valueFrom: {
                    secretKeyRef: {
                      name: r_name + "-db-secret",
                      key: "login"
                    }
                  }
                },
                {
                  name: "PG_ACC_PW",
                  valueFrom: {
                    secretKeyRef: {
                      name: r_name + "-db-secret",
                      key: "password"
                    }
                  }
                },
                {
                  name: "DATABASE_URL",
                  value: "postgresql://$(PG_ACC_LG):$(PG_ACC_PW)@" + r_name + "-db-svc:" + db_port + "/" + db.name,
                }
              ],
              ports: [
                {
                  containerPort: backend_port,
                  protocol: "TCP"
                }
              ],
              resources: backend.resources,
              readinessProbe: {
                tcpSocket: {
                  port: backend_port
                },
                initialDelaySeconds: 10,
                periodSeconds: 10
              },
              livenessProbe: {
                exec: {
                  command: [
                    "curl",
                    "http://" + r_name + "-backend-svc:" + backend_port + "/api/news/"
                  ]
                },
                initialDelaySeconds: 10,
                periodSeconds: 10
              },
              volumeMounts: [
                {
                  name: r_name + "-backend-volume",
                  mountPath: "/static"
                }
              ]
            }
          ],
          volumes: [
            {
              name: r_name + "-backend-volume",
              persistentVolumeClaim: {
                claimName: r_name + "-shared-pvc"
              }
            }
          ]
        }
      }
    }
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: r_name + "-backend-svc",
      namespace: r_namespace
    },
    spec: {
      selector: {
        app: r_name + "-backend"
      },
      ports: [
        {
          name: r_name + "-backend-port",
          port: backend_port,
          targetPort: backend.port,
          protocol: "TCP"
        }
      ]
    }
  }
]
