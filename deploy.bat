@echo off
echo Обновление проекта в GitHub...
git add .
git commit -m "Обновление: %date% %time%"
git push origin main
echo Готово! Изменения отправлены в GitHub.
echo GitHub Pages обновится автоматически через 1-2 минуты.
pause


