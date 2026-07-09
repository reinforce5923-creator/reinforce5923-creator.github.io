# Project Codex Notes

- Reply in Chinese by default for this blog project.
- When the user says they changed content and asks to sync/publish the blog, perform the full publish workflow:
  1. Check `git status --short`.
  2. Run `npm run build` to verify Hexo generation.
  3. Commit the relevant source changes with a concise message.
  4. Push `main` to `origin`.
  5. Wait for the GitHub Pages workflow to finish.
  6. Verify the live site at `https://yifankong823-creator.github.io/` contains the updated content.
- Do not assume the site is updated immediately after `git push`; confirm the GitHub Actions deploy job has completed and then re-check the live page.
