local r_name = std.extVar("r_name");
local r_namespace = std.extVar("r_ns");
local r_chart = std.extVar("r_chart");

local frontend = import 'config/frontend.libsonnet';

local frontend_port = std.get(frontend, "port_ext", default=frontend.port);

[
  {
    apiVersion: "v1",
    kind: "Pod",
    metadata: {
      name: r_name + "-test-frontend",
      namespace: r_namespace,
      annotations: {
        "helm.sh/hook": "test"
      }
    },
    spec: {
      containers: [
        {
          name: "curl-frontend-svc",
          image: "curlimages/curl:latest",
          command: [
            "curl"
          ],
          args: [
            "-s",
            "http://" + r_name + "-frontend-svc:" + frontend_port
          ]
        }
      ],
      restartPolicy: "Never"
    }
  }
]
