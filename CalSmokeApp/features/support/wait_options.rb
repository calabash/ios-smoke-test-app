require 'calabash-cucumber/wait_helpers'

module CalSmokeApp
  module WaitOpts

    include Calabash::Cucumber::WaitHelpers

    # A convenience function for passing wait options to a wait_for* function
    # @return [Hash] default wait options
    #
    # Pass this to your wait_for_* functions
    #
    # @param [String] query What you are waiting for
    # @param [Hash] opts wait options
    # @option opts :timeout defaults to wait_timeout()
    # @option opts :disappear iff true changes the error message to indicate
    #   that we were waiting for the view to disappear
    def wait_options(query, opts={})
      default_opts = {:disappear => false,
                      :timeout => wait_timeout}
      merged = default_opts.merge(opts)

      # handle :timeout => nil
      timeout = merged[:timeout] || wait_timeout

      if query.is_a?(String)
        qstr = query
      elsif query.is_a?(Array)
        qstr = query.join($-0)
      else
        raise ArgumentError, %Q[
Expected query to be a String or Array, but found:

#{query}
]
      end
      if merged[:disappear]
        msg = %Q[
Waited for #{timeout} seconds but could still see:

#{qstr}
]
      else
        msg = %Q[
Waited for #{timeout} seconds but did not see:

#{qstr}
]
      end

      {
        :timeout => timeout,
        :retry_frequency => retry_freq,
        :post_timeout => wait_step_pause,
        :timeout_message => msg
      }
    end

    # how long to wait for a view before failing
    def wait_timeout
      (ENV['WAIT_TIMEOUT'] || 2.0).to_f
    end

    # how often to retry querying for a view
    def retry_freq
      (ENV['RETRY_FREQ'] || 0.1).to_f
    end

    # the time to wait after a wait condition evals to +true+
    def wait_step_pause
      (ENV['POST_TIMEOUT'] || 0.0).to_f
    end
  end
end

World(CalSmokeApp::WaitOpts)
