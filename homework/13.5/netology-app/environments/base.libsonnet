{
  release: "r1",
  chart: "netology-app",
  backend: {
    replicas: 1,
    port: 9000,
    image_tag: "1.0",
    resources: {}
  },
  frontend: {
    replicas: 1,
    port: 80,
    port_ext: 8000,
    image_tag: "1.0",
    resources: {
      limits: {
        cpu: "0.9",
        memory: "256Mi"
      },
      requests: {
        cpu: "250m",
        memory: "128Mi"
      }
    }
  },
  db: {
    replicas: 1,
    port: 5432,
    user: "postgres",
    password: "postgres",
    name: "news"
  },
  volume: {
    size: "512Mi",
    use_nfs: "true"
  },
  ext: {
    ip: "213.180.193.58",
    port: 80,
    middle_port: 8080,
    path: "ext"
  },
  images: {
    frontend: "artemshtepa/netology-app-frontend",
    backend: "artemshtepa/netology-app-backend",
    db: "postgres:13-alpine",
    pullPolicy: "IfNotPresent"
  }
}
