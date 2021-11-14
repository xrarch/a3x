.section text

.ds ANTE
.dl _a3xEntry

.extern a3xEntry

.extern a3xReturn ;see a3x.df

.extern a3xFwctx

_a3xEntry:
.global _a3xEntry
	subi sp, sp, 4
	mov  long [sp], lr

	la   t0, a3xFwctx
	mov  long [t0], sp

	jal  a3xEntry

	j    a3xReturn

.entry _a3xEntry