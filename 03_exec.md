# exec

## Cease control

* **`exit`** cease to exist, either contentedly or grumbling.

* **`system`** cease control while some other process runs,
get back control when that other process is done.

* **`exec`** cease to exist, leaving a successor

yyi plain_exec

## Often combined

yyi fork_exec_wait

## Abbreviations

`fork` + `exec` = `spawn`

`fork` + `exec` + `wait` = `system`

That's true on UNIX (Linux, Mac).  But `spawn` and `system` may
be coded differently on other systems (Windows).  So those two
are generally more portable, they may exist on platforms that do
not provide `fork`.

## Exercise

* Run the fork_exec_wait - Example on your laptop.

* Port it to using `spawn`.
