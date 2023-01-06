local r_name = std.extVar("r_name");
local r_namespace = std.extVar("r_ns");
local r_chart = std.extVar("r_chart");

local db = import 'config/db.libsonnet';
local backend = import 'config/backend.libsonnet';

local backend_port = if std.objectHas(backend, "port_ext") then backend.port_ext else backend.port;

[
  {
    apiVersion: "v1",
    kind: "Pod",
    metadata: {
      name: r_name + "-test-backend",
      namespace: r_namespace,
      annotations: {
        "helm.sh/hook": "test"
      }
    },
    spec: {
      containers: [
        {
          name: "curl-backend-srv",
          image: "curlimages/curl:latest",
          command: [
            "curl"
          ],
          args: [
            "-s",
            "http://" + r_name + "-backend-svc:" + backend_port + "/api/" + db.name + "/"
          ]
        }
      ],
      restartPolicy: "Never"
    }
  }
]
