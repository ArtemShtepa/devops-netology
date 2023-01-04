local base = import './base.libsonnet';

base {
  frontend +: {
    replicas: 3
  },
  backend +: {
    replicas: 3
  },
  db +: {
    replicas: 3
  }
}
