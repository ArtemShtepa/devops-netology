local p = import '../params.libsonnet';
local frontend = p.frontend;
local backend = p.backend;
local images = p.images;

local r_name = p.release;
local r_namespace = std.extVar("qbec.io/env");
local r_chart = p.chart;

local frontend_port = std.get(frontend, "port_ext", default=frontend.port);
local backend_port = std.get(backend, "port_ext", default=backend.port);

[
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      labels: {
        app: r_name + "-frontend"
      },
      name: r_name + "-frontend",
      namespace: r_namespace
    },
    spec: {
      replicas: std.get(frontend, "replicas", default=1),
      selector: {
        matchLabels: {
          app: r_name + "-frontend"
        }
      },
      template: {
        metadata: {
          labels: {
            app: r_name + "-frontend"
          }
        },
        spec: {
          containers: [
            {
              name: r_chart + "-frontend",
              image: images.frontend + ":" + frontend.image_tag,
              imagePullPolicy: images.pullPolicy,
              env: [
                {
                  name: "BASE_URL",
                  value: "http://" + r_name + "-backend-svc:" + backend_port,
                }
              ],
              ports: [
                {
                  containerPort: frontend.port,
                  protocol: "TCP"
                }
              ],
              resources: frontend.resources,
              volumeMounts: [
                {
                  name: r_name + "-frontend-volume",
                  mountPath: "/data"
                }
              ]
            }
          ],
          volumes: [
            {
              name: r_name + "-frontend-volume",
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
      name: r_name + "-frontend-svc",
      namespace: r_namespace
    },
    spec: {
      selector: {
        app: r_name + "-frontend"
      },
      ports: [
        {
          name: r_name + "-frontend-port",
          port: frontend_port,
          targetPort: frontend.port,
          protocol: "TCP"
        }
      ]
    }
  }
]
