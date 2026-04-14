Rack::Attack.cache.store = if Rails.env.test?
  ActiveSupport::Cache::MemoryStore.new
else
  ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
end

Rack::Attack.throttle("auth/ip", limit: 10, period: 60) do |request|
  if request.path.start_with?("/api/v1/auth/") && request.post?
    request.ip
  end
end

Rack::Attack.throttle("requests/ip", limit: 300, period: 60) do |request|
  request.ip
end
