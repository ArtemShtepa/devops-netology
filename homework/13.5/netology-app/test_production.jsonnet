local p = import './environments/production.libsonnet';

local r_name = p.release;
local r_namespace = 'production';

local db = p.db;
local backend = p.backend;
local frontend = p.frontend;

local backend_port = if std.objectHas(backend, "port_ext") then backend.port_ext else backend.port;
local frontend_port = std.get(frontend, "port_ext", default=frontend.port);

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
  },
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
