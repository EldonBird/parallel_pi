{application,parallelpi,
             [{description,"Monte Carlo Parallel Pi Estimation"},
              {vsn,"0.1.0"},
              {modules,[gen_manager,gen_worker_agm,gen_worker_mc,parallelpi,
                        sup_manager,sup_worker_agm,sup_worker_mc]},
              {registered,[gen_manager,gen_sup]},
              {mod,{parallelpi,[]}},
              {applications,[kernel,stdlib]}]}.
