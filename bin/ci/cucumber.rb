#!/usr/bin/env ruby

require "run_loop"
require "luffa"
require "bundler"

cucumber_args = "#{ARGV.join(' ')}"

this_dir = File.expand_path(File.dirname(__FILE__))
working_directory = File.join(this_dir, '..', '..', 'CalSmokeApp')

def select_sim_by_name(simctl, regex)
  simctl.simulators.select do |sim|
    sim.to_s[/#{regex} \(/]
  end.sort_by do |sim|
    sim.version
  end.last
end

Dir.chdir(working_directory) do

  Bundler.with_clean_env do

    FileUtils.rm_rf("reports")
    FileUtils.mkdir_p("reports")

    xcode = RunLoop::Xcode.new
    simctl = RunLoop::Simctl.new

    iphone_xs = select_sim_by_name(simctl, "iPhone Xs")
    iphone_xr = select_sim_by_name(simctl, "iPhone Xʀ")
    iphone_11 = select_sim_by_name(simctl, "iPhone 11")
    iphone_11_pro = select_sim_by_name(simctl, "iPhone 11 Pro")

    if xcode.version.major < 11
      devices = {
        :iphoneXs => iphone_xs,
        :iphoneXr => iphone_xr
      }
    else
      devices = {
        :iphone11 => iphone_11,
        :iphone11Pro => iphone_11_pro
      }
    end

    devices.delete_if { |k, v| v.nil? }

    RunLoop::CoreSimulator.terminate_core_simulator_processes

    passed_sims = []
    failed_sims = []
    devices.each do |key, simulator|
      args = [
        "bundle", "exec", "cucumber",
        "-t", "@rotation",
        "-p", "simulator",
        "-f", "junit", "-o", "reports/junit/#{key}",
        "#{cucumber_args}"
      ]

      env_vars = {
        "DEVICE_TARGET" => simulator.udid,
      }

      RunLoop::CoreSimulator.terminate_core_simulator_processes

      exit_code = Luffa.unix_command(args.join(" "),
                                     {:exit_on_nonzero_status => false,
                                      :env_vars => env_vars})
      if exit_code == 0
        passed_sims << simulator.to_s
      else
        failed_sims << simulator.to_s
      end
    end

    Luffa.log_info '=== SUMMARY ==='
    Luffa.log_info ''
    Luffa.log_info 'PASSING SIMULATORS'
    passed_sims.each { |sim| Luffa.log_info(sim) }
    Luffa.log_info ''
    Luffa.log_info 'FAILING SIMULATORS'
    failed_sims.each { |sim| Luffa.log_info(sim) }

    sims = devices.count
    passed = passed_sims.count
    failed = failed_sims.count

    puts ''
    Luffa.log_info "passed on '#{passed}' out of '#{sims}'"

    # if none failed then we have success
    exit 0 if failed == 0
    
    # ci environment is not stable enough to have all tests passing
    exit failed unless RunLoop::Environment.azurepipelines?

    # we'll take 75% passing as good indicator of health
    expected = 75
    actual = ((passed.to_f/sims.to_f) * 100).to_i

    if actual >= expected
      Luffa.log_pass "We failed '#{failed}' sims, but passed '#{actual}%' so we say good enough"
      exit 0
    else
      Luffa.log_fail "We failed '#{failed}' sims, which is '#{actual}%' and not enough to pass"
      exit 1
    end
  end
end
