project = "go-fiber-waypoint"

app "go-fiber-waypoint" {
  labels = {
    "service" = "go-fiber-waypoint"
  }

  build {
    // buildpacksを利用
    use "pack" {
      builder="paketobuildpacks/builder:tiny"
    }

    registry {
      use "docker" {
        image = "asia.gcr.io/${GCP_PROJECT_ID}/go-fiber-waypoint"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "google-cloud-run" {
      // プロジェクト
      project = "${GCP_PROJECT_ID}"
      // 東京リージョン
      location = "asia-northeast1" 

      capacity {
        memory                     = 128
        cpu_count                  = 1
        max_requests_per_container = 10
        request_timeout            = 300
      }

      auto_scaling {
        max = 2
      }
    }
  }

  release {
    use "google-cloud-run" {}
  }
}