import Config

config :n2o,
  app: :test_task,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  upload: "./priv/static",
  nitro_prolongate: true,
  ttl: 60,
  protocols: [:nitro_n2o, :n2o_ftp],
  routes: TestTask.Application

config :kvs,
  dba: :kvs_rocks,
  mnesia_context: :sync_transaction,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream]
