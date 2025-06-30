{application,parallelpi,
             [{description,"Monte Carlo Parallel Pi Estimation"},
              {vsn,"0.1.0"},
              {modules,[gen_manager_long,gen_worker_long,parallelpi,
                        sup_manager_long,sup_worker_long]},
              {registered,[gen_manager,gen_sup]},
              {mod,{parallelpi,[]}},
              {applications,[kernel,stdlib]}]}.
