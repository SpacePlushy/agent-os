## Optimization & CP-SAT best practices

### Google OR-Tools CP-SAT Solver

- **Prefer CP-SAT**: Use CP-SAT solver for constraint programming problems; it's more powerful than older CP solver
- **Problem Suitability**: CP-SAT excels at:
  - Scheduling problems (job shop, resource allocation)
  - Assignment problems (workers to tasks)
  - Routing problems (TSP, VRP)
  - Packing and bin packing
  - Combinatorial optimization with logical constraints
- **Linear Programming**: For pure LP problems without integer constraints, use OR-Tools linear solver instead

### Model Building

- **Clear Variable Names**: Name variables descriptively (`task_start_time`, `worker_assigned`, `machine_id`)
- **Explicit Bounds**: Always specify meaningful bounds for integer variables; tighter bounds improve solve time
- **Variable Types**: Use `new_int_var()` for integers, `new_bool_var()` for binary decisions, `new_interval_var()` for scheduling
- **Constants as Parameters**: Define problem constants at the top; don't hardcode magic numbers
- **Modular Constraints**: Group related constraints; add comments explaining business logic

### Constraint Formulation

- **Use High-Level Constraints**: Prefer built-in constraints (`add_all_different()`, `add_no_overlap()`) over manual formulations
- **Linear Expressions**: Build linear expressions with `LinearExpr` or direct arithmetic (e.g., `2*x + 3*y`)
- **Logical Constraints**: Use `add_bool_or()`, `add_bool_and()`, `add_implication()` for logical relationships
- **Conditional Constraints**: Use `only_enforce_if()` for constraints that apply conditionally
- **Redundant Constraints**: Add redundant constraints to guide solver; they can significantly improve performance
- **Symmetry Breaking**: Add symmetry-breaking constraints for problems with identical resources/tasks

### Objective Functions

- **Minimize or Maximize**: Use `model.minimize()` or `model.maximize()`; express as linear combination of variables
- **Weighted Objectives**: Use coefficients to balance multiple goals in single objective
- **Multi-Objective**: For true multi-objective optimization, solve iteratively with different priorities
- **Objective Scaling**: Scale objective coefficients to avoid numerical issues with very large/small values

### Solving & Configuration

- **Solver Parameters**: Configure solver via `solver.parameters`:
  - `num_workers`: Set to CPU count for parallel solving (e.g., 8)
  - `max_time_in_seconds`: Set timeout for long-running problems
  - `log_search_progress`: Enable for monitoring solve progress
  - `cp_model_presolve`: Usually keep enabled (default) for preprocessing
- **Solution Checking**: Always check `status` before accessing solution (OPTIMAL, FEASIBLE, INFEASIBLE, UNKNOWN)
- **Logging**: Enable search logging during development; disable in production
- **Timeout Handling**: Handle UNKNOWN status with timeout; use best found solution if FEASIBLE

### Solution Extraction

- **Check Status First**: Always verify `status == cp_model.OPTIMAL or status == cp_model.FEASIBLE`
- **Access Values**: Use `solver.value(variable)` for integer variables, `solver.boolean_value(var)` for booleans
- **Objective Value**: Get with `solver.objective_value`
- **Solution Callbacks**: Use solution callbacks for collecting multiple solutions or early stopping
- **Statistics**: Log solver statistics (conflicts, branches, wall_time) for performance tuning

### Performance Optimization

- **Tight Variable Bounds**: Reduce search space by tightening bounds based on problem constraints
- **Problem Decomposition**: Break large problems into smaller subproblems when possible
- **Incremental Solving**: For similar problems, warm-start from previous solutions
- **Heuristics**: Provide initial solutions with hints to guide solver
- **Parallel Solving**: Use multiple workers for complex problems
- **Preprocessing**: Let solver preprocess; it often simplifies problem significantly

### Common Patterns

#### Scheduling with No-Overlap
```python
# Create interval variables for tasks
intervals = []
for task in tasks:
    start = model.new_int_var(0, horizon, f'start_{task}')
    duration = task_durations[task]
    end = model.new_int_var(0, horizon, f'end_{task}')
    interval = model.new_interval_var(start, duration, end, f'interval_{task}')
    intervals.append(interval)

# Ensure tasks don't overlap on resource
model.add_no_overlap(intervals)
```

#### Assignment with All Different
```python
# Assign workers to tasks (one-to-one)
assignments = []
for worker in workers:
    for task in tasks:
        var = model.new_bool_var(f'worker_{worker}_task_{task}')
        assignments.append(var)

# Each worker assigned exactly once
for worker in workers:
    model.add(sum(assignments[worker][task] for task in tasks) == 1)

# Each task gets exactly one worker
for task in tasks:
    model.add(sum(assignments[worker][task] for worker in workers) == 1)
```

#### Conditional Constraints with Enforcement
```python
# If task_active, then start_time <= deadline
task_active = model.new_bool_var('task_active')
model.add(start_time <= deadline).only_enforce_if(task_active)
model.add(start_time == 0).only_enforce_if(~task_active)
```

### Optimization Model Checklist

- [ ] All variables have meaningful names and tight bounds
- [ ] Constraints correctly model business rules
- [ ] Objective function aligns with optimization goal
- [ ] Solver parameters configured (workers, timeout)
- [ ] Solution status checked before accessing values
- [ ] Edge cases handled (no solution, timeout)
- [ ] Statistics logged for performance monitoring
- [ ] Code includes comments explaining complex constraints

### Testing Optimization Models

- **Small Test Cases**: Create small instances with known optimal solutions
- **Infeasibility Testing**: Verify model correctly detects infeasible problem instances
- **Optimality Testing**: For small problems, verify solver finds known optimal solution
- **Performance Testing**: Benchmark solve times on representative problem sizes
- **Constraint Validation**: Test that constraints are correctly enforced in solutions

### Common Pitfalls

- **Unbounded Variables**: Always set bounds; unbounded variables slow solver dramatically
- **Ignoring Status**: Never access solution without checking status first
- **Too Many Variables**: Simplify model if variable count exceeds 100k; consider reformulation
- **Weak Constraints**: Ensure constraints are strong enough to eliminate invalid solutions
- **Objective Mismatch**: Verify objective function actually measures what you want to optimize
- **No Timeout**: Always set `max_time_in_seconds` for production use

### Alternative Solvers

- **Linear Programming**: Use `pywraplp.Solver()` for pure LP/MIP without logical constraints
- **Routing**: Use OR-Tools routing library for VRP/TSP instead of raw CP-SAT
- **PuLP**: Consider PuLP for simpler MIP models with straightforward syntax
- **Python-MIP**: Alternative MIP library with good CBC/Gurobi interfaces

### Integration Patterns

- **Batch Processing**: Solve multiple independent problems in parallel using multiprocessing
- **Web APIs**: Run solver in background task; return job ID; poll for results
- **Caching**: Cache solutions for frequently seen problem instances
- **Approximations**: For very large problems, use heuristics first, then optimize best solutions
- **Hybrid Approaches**: Combine CP-SAT with heuristics or machine learning for complex problems

### Documentation

- **Model Description**: Document what the model optimizes and key assumptions
- **Variable Naming**: Use clear naming convention; document variable meanings
- **Constraint Explanation**: Comment complex constraints with business logic
- **Parameter Tuning**: Document solver parameter choices and reasoning
- **Expected Performance**: Document expected solve times for different problem sizes
