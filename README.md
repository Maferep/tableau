# Tableau

Tableau is a basic image board with support for modern web formats (webp, AVIF, JPEGXL).

## Running
### development
Initialize database with:
```bin/rails db:migrate```
Start development server:
```bin/rails server```
### production
Generate production assets with
```RAILS_ENV=production bin/rails assets:precompile```
```RAILS_ENV=production bin/rails server```

## Versions
Ruby 3.4
Rails 8.1

## Additional dependencies
- Filepond for file uploads
