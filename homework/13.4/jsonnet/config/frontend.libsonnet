{
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
}
