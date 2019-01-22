# 1. Clear retry set

Sidekiq::RetrySet.new.clear

# 2. Clear scheduled jobs 

Sidekiq::ScheduledSet.new.clear

# 3. Clear 'Processed' and 'Failed' jobs

Sidekiq::Stats.new.reset

# 3. Clear 'Dead' jobs statistics

Sidekiq::DeadSet.new.clear

# Via API

require 'sidekiq/api'

stats = Sidekiq::Stats.new
stats.queues
# {"production_mailers"=>25, "production_default"=>1}

queue = Sidekiq::Queue.new('queue_name')
queue.count
queue.clear
