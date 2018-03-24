---
number: 2
subject: Предмет
author:
	- Иванов И. И.
inspector:
	- Петров П. П.
name: Вариант 10
---

# Цель работы

В отдельном файле `header.def` были добавлены пакеты tikz.

# Задача

Задача

\begin{center}
\begin{tikzpicture}[pattern color=gray]
\coordinate (paper0) at (0,0);
\coordinate (paper1) at ($ (paper0) + (15,12) $);

\draw[very thin, lightgray, step=0.1] (paper0) grid (paper1);
\draw[thin, gray, step=1] (paper0) grid (paper1);
\draw (paper0) rectangle (paper1);

\end{tikzpicture}
\end{center}

# Вывод

Вывод
