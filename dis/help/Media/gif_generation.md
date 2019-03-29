# How did you generate media
1. Generate the mov using quicktime
2. Use ffmpeg to convert to gif:  
```bash
ffmpeg -i [INPUT].mov -vf scale=iw*.375:ih*.375 -r "15" [OUTPUT].gif
```