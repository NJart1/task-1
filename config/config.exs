import Config

config :n2o,
  app: :test_1,
  port: 8020,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  upload: "./priv/static",
  nitro_prolongate: true,
  ttl: 60,
  protocols: [:nitro_n2o, :n2o_ftp],
  routes: Test1.Routes

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream]
