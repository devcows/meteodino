if Rails.env.development?
  Annotate.set_defaults({
                            :show_indexes => 'true',
                            :simple_indexes => 'false',
                            :model_dir => 'app/models',
                            :include_version => 'false',
                            :require => '',
                            :exclude_tests => 'false',
                            :exclude_fixtures => 'false',
                            :exclude_factories => 'false',
                            :ignore_model_sub_dir => 'false',
                            :skip_on_db_migrate => 'false',
                            :format_bare => 'true',
                            :format_rdoc => 'false',
                            :format_markdown => 'false',
                            :sort => 'false',
                            :force => 'false',
                            :trace => 'false',
                        })
end
