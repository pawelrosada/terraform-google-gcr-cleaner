module "gcr_cleaner" {
  source = "../.."

  app_engine_application_location = "europe-west3"
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        {
          # in `test/nginx` repository, delete all untagged images
          name = "test/nginx"
        },
        {
          # in `test/python` repository, delete all images older than 30 days (720h)
          name  = "test/python"
          grace = "720h"
        }
      ]
    }
  ]
  gar_repositories = [
    {
      region = "eu"
      repositories = [
        {
          # in `python_repo/pythone_cache` repository, delete all `beta` tags
          name           = "projects/python//locations/europe-central2/repositorie/python_repo/pythone_cache"
          tag_filter_all = "^beta.+$"
        }
      ]
    }
  ]
}
