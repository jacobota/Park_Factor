"""Park Factor persistent stats store (DuckDB).

Phase 1: season-snapshot tables. A nightly job snapshots the bbref + Savant + MLB-API
season frames the Flask routes used to scrape live, so requests read a local DuckDB file
(sub-millisecond) instead of hitting bbref/Savant on every call.

Local-first by design (see .claude/plans/Park_Factor_Data_Switch_1.0.md): the same code points
at MotherDuck later by setting PARKFACTOR_DUCKDB to an `md:` connection string.

Event-level pitch data (the foundation for Player Rating / per-game) is deliberately NOT here
yet — that's Phase 2.
"""
