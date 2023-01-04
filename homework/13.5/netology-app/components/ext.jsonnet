local p = import '../params.libsonnet';
local db = p.db;
local backend = p.backend;
local external = p.ext;

local r_name = p.release;
local r_namespace = std.extVar("qbec.io/env");

local db_port = std.get(db, "port_ext", default=db.port);
local backend_port = if std.objectHas(backend, "port_ext") then backend.port_ext else backend.port;

[
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: r_name + "-ext-svc",
      namespace: r_namespace
    },
    spec: {
      type: "ClusterIP",
      clusterIP: "None",
      ports: [
        {
          name: r_name + "-app",
          port: external.middle_port,
          protocol: "TCP",
          targetPort: external.middle_port
        },
      ]
    }
  },
  {
    apiVersion: "networking.k8s.io/v1",
    kind: "Ingress",
    metadata: {
      name: r_name + "-ext-ing",
      namespace: r_namespace
    },
    spec: {
      rules: [
        {
          http: {
            paths: [
              {
                path: "/" + external.path,
                pathType: "Exact",
                backend: {
                  service: {
                    name: r_name + "-ext-svc",
                    port: {
                      number: external.middle_port
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  },
  {
    apiVersion: "v1",
    kind: "Endpoints",
    metadata: {
      name: r_name + "-ext-svc",
      namespace: r_namespace
    },
    subsets: [
      {
        addresses: [
          {
            ip: external.ip
          }
        ],
        ports: [
          {
            name: r_name + "-api",
            port: external.port,
            protocol: "TCP"
          }
        ]
      }
    ]
  }
]
