local p = import '../params.libsonnet';

local r_name = p.release;
local r_namespace = std.extVar("qbec.io/env");
local r_chart = p.chart;

local db = p.db;
local images = p.images;

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
      replicas: std.get(db, "replicas", default=1),
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
              ]
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
  }
]
