local r_name = std.extVar("r_name");
local r_namespace = std.extVar("r_ns");
local r_chart = std.extVar("r_chart");

local db = import 'config/db.libsonnet';
local images = import 'config/images.libsonnet';

local db_port = std.get(db, "port_ext", default=db.port);

[
  {
    apiVersion: "apps/v1",
    kind: "StatefulSet",
    metadata: {
      labels: {
        app: r_name + "-db"
      },
      name: r_name + "-db",
      namespace: r_namespace
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: r_name + "-db",
        },
      },
      template: {
        metadata: {
          labels: {
            app: r_name + "-db",
          },
        },
        spec: {
          containers: [
            {
              name: r_chart + "-db",
              image: images.db,
              imagePullPolicy: images.pullPolicy,
              env: [
                {
                  name: "POSTGRES_USER",
                  valueFrom: {
                    secretKeyRef: {
                      name: r_name + "-db-secret",
                      key: "login"
                    }
                  }
                },
                {
                  name: "POSTGRES_PASSWORD",
                  valueFrom: {
                    secretKeyRef: {
                      name: r_name + "-db-secret",
                      key: "password"
                    }
                  }
                },
                {
                  name: "POSTGRES_DB",
                  value: db.name,
                }
              ],
              volumeMounts: [
                {
                  name: r_name + "-db-volume",
                  mountPath: "/var/lib/postgresql/data"
                }
              ]
            }
          ],
          volumes: [
            {
              name: r_name + "-db-volume",
              persistentVolumeClaim: {
                claimName: r_name + "-db-pvc"
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
      name: r_name + "-db-svc",
      namespace: r_namespace
    },
    spec: {
      selector: {
        app: r_name + "-db"
      },
      ports: [
        {
          name: r_name + "-db-port",
          port: db_port,
          targetPort: db.port,
          protocol: "TCP",
        }
      ]
    }
  },
  {
    apiVersion: "v1",
    kind: "Secret",
    metadata: {
      name: r_name + "-db-secret",
      namespace: r_namespace
    },
    type: "Opaque",
    data: {
      login: std.base64(std.get(db, "user", default="postgres")),
      password: std.base64(std.get(db, "password", default="postgres"))
    }
  },
  {
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
      name: r_name + "-db-pvc",
      namespace: r_namespace
    },
    spec: {
      [if std.asciiLower(db.use_nfs) == "true" then "storageClassName" else null]: "nfs",
      accessModes: [
        "ReadWrite" + if std.asciiLower(db.use_nfs) == "true" then "Many" else "Once"
      ],
      resources: {
        requests: {
          storage: db.size
        }
      }
    }
  },
  if std.asciiLower(db.use_nfs) != "true" then
  {
    apiVersion: "v1",
    kind: "PersistentVolume",
    metadata: {
      name: r_name + "-pv"
    },
    spec: {
      accessModes: [
        "ReadWriteOnce"
      ],
      capacity: {
        storage: db.size
      },
      hostPath: {
        path: "/data/pv-" + r_name
      },
      persistentVolumeReclaimPolicy: "Retain",
    }
  }
]
