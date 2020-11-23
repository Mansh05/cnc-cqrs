# Cnc::Cqrs

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cnc/cqrs`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cnc-cqrs'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cnc-cqrs

## Usage

In initializer

```ruby 
Cnc::Cqrs.setup do |config|
  config.file_path = "#{Rails.root}/cqrs" #This is the main root folder
  # where all the command files are there
end
```

# Adaptors (Middlewares)

Since we need to have adaptors for the event and command handlers.
Currently we have two ways to do so

1. Cnc Workflow
  This gem is a gem for cnc which defines different workflow. It can 
  be configured with categories and it requrires cnc gem.
  
  As seen below the service requires 
  
  ```yml
    code: 'TENANT MS WORKFLOW'
    pipelines:
      services:
        code: TENCONF02
        workers: []
        cqrs:
          set: true
        categories:
          telco:
            create_tenant: telco_tenant_creation
        workflows:
          -
            name: create_tenant
            description: This flow will deal with tenant creation
            ref: tenant_creater
          -
            name: tenant_created
            description: Tenant Event
            ref: tenant_created
          -
            name: tenant_update
            description: This flow will deal with tenant profile update
            ref: tenant_updater
          -
            name: template_update
            description: This flow will deal with tenant profile update
            ref: template_updater
          -
            name: create_service
            description: This flow will deal with service creation
            ref: service_creater
          -
            name: update_service
            description: This flow will deal with service updation
            ref: service_updater
          -
            name: create_project
            description: Create Projects for loggers
            ref: project_creater
          -
            name: create_log
            description: Create logs for Particular project
            ref: log_creater
          -
            name: approve_tenant
            description: Approves tenants and publishes
            ref: tenant_approval
  ```

Now as per configuration config.file_path = "#{Rails.root}/cqrs"

we need to create a folder cqrs

Copy and paste it in normal editor to see the correct tree

├───cnc/
│   ├───config/
│   │   ├───emails/
│   │   │   └───await_tenant_approval.yml
│   │   ├───models/
│   │   │   ├───project_detail_serializer.yml
│   │   │   ├───project_list_serializer.yml
│   │   │   ├───service_detail_serializer.yml
│   │   │   └───service_list_serializer.yml
│   │   ├───profilers/
│   │   │   └───telco_tenant_creation.yml
│   │   ├───tenants/
│   │   │   ├───cnc_suite.yml
│   │   │   └───telco.yml
│   │   ├───workflows/
│   │   │   ├───log_creater.yml
│   │   │   ├───project_creater.yml
│   │   │   ├───service_creater.yml
│   │   │   ├───service_updater.yml
│   │   │   ├───template_updater.yml
│   │   │   ├───tenant_approval.yml
│   │   │   ├───tenant_created.yml
│   │   │   ├───tenant_creater.yml
│   │   │   ├───tenant_updated.yml
│   │   │   └───tenant_updater.yml
│   │   ├───email.yml
│   │   ├───error_handlers.yml
│   │   ├───ncs.yml
│   │   ├───profiles.yml
│   │   ├───read_models.yml
│   │   └───workflow.yml
│   └───config.yml
└───cqrs/
    └───commands/
        └───tenant/
            └───create.yml



Each command can be inside its particular domain with a yml configuration.
The commands will have its configuration

create.yml command will have

```yml
name: create_tenant # This is the name of the command, this will be the trigger for command bus to know
meta:
  flow: create_tenant # THis is dynamic meta properties, it can be anything
event: # If you have a event that needs to be triggered after the command, you define it here
  name: tenant_created # Event name that needs to be triggered
  references: # THis is something a event source will look into. While sourcing the data is build through references
    -
      key:
        - tenant
        - record
      klass: Tenant
      from: tenant
```

# How to setup the command bus

you just need to include a module namely, include Cnc::Cqrs::CommandBus to the application controller.
After that we can call out a command, with 

```ruby
  command('create_tenant') # THis create tenant is the command that we had created above in the yml file
```

# Specs

The gem provides a spec configuration which can be used while writing specs.

```ruby
require 'cnc/cqrs/spec'
```

## Development

bundle install

## Contributing

Contribution will be scoped within selise. Anyone can contribute and point the branch from
feature or bug or fix to release/cqrs

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cnc::Cqrs project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cnc-cqrs/blob/master/CODE_OF_CONDUCT.md).
