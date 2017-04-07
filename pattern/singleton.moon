class Singleton
  get_instance: (...) =>
    if @_instance == nil
      @_instance = @@ ...
    @_instance

-- Example 1
-- class A extends Singleton
--   ...

-- Example 2 *recommended*
-- class B
--   get_instance: Singleton.get_instance