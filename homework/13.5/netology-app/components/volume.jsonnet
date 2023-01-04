local p = import '../params.libsonnet';

local volume = p.volume;

local r_name = p.release;
local r_namespace = std.extVar("qbec.io/env");
local r_chart = p.chart;

[
  {
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
      name: r_name + "-shared-pvc",
      namespace: r_namespace
    },
    spec: {
      [if std.asciiLower(volume.use_nfs) == "true" then "storageClassName" else null]: "nfs",
      accessModes: [
        "ReadWriteMany"
      ],
      resources: {
        requests: {
          storage: volume.size
        }
      }
    }
  },
  if std.asciiLower(volume.use_nfs) != "true" then
  {
    apiVersion: "v1",
    kind: "PersistentVolume",
    metadata: {
      name: r_name + "-pv"
    },
    spec: {
      accessModes: [
        "ReadWriteMany"
      ],
      capacity: {
        storage: volume.size
      },
      hostPath: {
        path: "/data/pv-" + r_name
      },
      persistentVolumeReclaimPolicy: "Retain",
    }
  }
]
