local r_name = std.extVar("r_name");
local r_namespace = std.extVar("r_ns");
local r_chart = std.extVar("r_chart");

local external = import 'config/external.libsonnet';

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
