module "gcr_cleaner" {
  source = "../.."

  # If you want to create your App Engine Application using terraform, uncomment the following
  # create_app_engine_app = true

  app_engine_application_location          = "europe-west3"
  cloud_run_service_name                   = "gcr-cleaner-helsinki"
  cloud_run_service_location               = "europe-north1"
  cloud_run_service_maximum_instances      = 300
  cloud_run_service_timeout_seconds        = 300
  gcr_cleaner_image                        = "europe-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner:latest"
  cloud_scheduler_job_schedule             = "0 2 * * 5"
  cloud_scheduler_job_time_zone            = "Europe/Helsinki"
  cloud_scheduler_job_attempt_deadline     = 600
  cloud_scheduler_job_retry_count          = 3
  cloud_scheduler_job_min_backoff_duration = 10
  cloud_scheduler_job_max_backoff_duration = 300
  cloud_scheduler_job_max_retry_duration   = 10
  cloud_scheduler_job_max_doublings        = 2
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        {
          # in `test/nginx` repository, delete all `beta` tags
          name           = "test/nginx"
          tag_filter_all = "^beta.+$"
        },
        {
          # in `test/nginx` repository, delete all images older than 30 days (720h)
          name  = "test/nginx"
          grace = "720h"
        },
        {
          # in `test/python` repository, if there is at least one `alpha` tag,
          # delete all and keep only 3 tags
          name           = "test/python"
          keep           = 3
          tag_filter_any = "^alpha.+$"
        },
        {
          # in `test/tools/ci` repository and all its child repositories, keep only 5 images
          name      = "test/tools/ci"
          keep      = 5
          recursive = true
        }
      ]
    },
    {
      # in all repositories, delete all untagged images
      clean_all      = true
      storage_region = "eu"
    },
    {
      # in all repositories, keep 5 `beta` tags, ignore anything newer than 5 days
      clean_all      = true
      storage_region = "eu"
      parameters = {
        keep           = 5
        grace          = "120h"
        tag_filter_all = "^beta.+$"
      }
    }
  ]
  gar_repositories = [
    {
      storage_region = "eu"
      repositories = [
        {
          # in `python_repo/pythone_cache` repository, delete all `beta` tags
          name           = "projects/python//locations/europe-central2/repositorie/python_repo/pythone_cache"
          tag_filter_all = "^beta.+$"
        },
        {
          # in `python_repo/pythone` repository, delete all images older than 30 days (720h)
          name  = "projects/python/locations/europe-central2/repositorie/python_repo/pythone"
          grace = "720h"
        },
        {
          # in `python_repo/pythone_test` repository, if there is at least one `alpha` tag,
          # delete all and keep only 3 tags
          name           = "projects/python/locations/europe-central2/repositorie/python_repo/pythone_test"
          keep           = 3
          tag_filter_any = "^alpha.+$"
        },
        {
          # in `test/tools/ci` repository and all its child repositories, keep only 5 images
          name      = "test/tools/ci"
          keep      = 5
          recursive = true
        }
      ]
    },
    {
      project_id = "foobar-123"
      region     = "europe-west1"
      name       = "myrepo"
      parameters = {
        grace      = "180h"
        keep       = 3
        tag_filter = "^alpha.+$"
      }
    }
  ]
}
