{application,parallelpi,
             [{description,"Monte Carlo Parallel Pi Estimation"},
              {vsn,"0.1.0"},
              {modules,[gen_manager,gen_sup,gen_worker,man_sup,parallelpi]},
              {registered,[gen_manager,gen_sup]},
              {mod,{parallelpi,[]}},
              {applications,[kernel,stdlib]}]}.
