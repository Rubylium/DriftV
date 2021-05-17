var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var twig = require('gulp-twig');
var htmlbeautify = require('gulp-html-beautify');
var babel = require('gulp-babel');
var imagemin = require('gulp-imagemin');
var browserSync = require('browser-sync');

gulp.task('sass', () =>
    gulp.src('app/scss/**/*.scss') 
    .pipe(sass().on('error', sass.logError))
    .pipe(autoprefixer({
        overrideBrowserslist: ['last 2 versions'],
        cascade: false
    }))
    .pipe(gulp.dest('dist/css/'))
    .pipe(browserSync.reload({
        stream: true
    })) 
)

gulp.task('twig', () =>
    gulp.src('app/twig/**/!(_*)*.twig')
    .pipe(twig())
    .pipe(htmlbeautify())
    .pipe(gulp.dest('dist/'))
)


gulp.task('babel', () =>
    gulp.src('app/js/**/*.js')
    .pipe(babel({
        presets: ['@babel/env'],        
    }))
    .pipe(gulp.dest('dist/js/'))
);

gulp.task('image', () =>
    gulp.src('app/img/*')
    .pipe(imagemin())
    .pipe(gulp.dest('dist/images/'))
);

gulp.task('browserSync', function() {
    browserSync({
        server: {
        baseDir: 'app'
        },
    })
})

gulp.task('watch', function(){
    gulp.watch('app/scss/**/*.scss', gulp.series('sass')); 
    gulp.watch('app/twig/**/*.twig',gulp.series('twig')); 
    gulp.watch('app/js/**/*.js',gulp.series('babel')); 
    gulp.watch('app/img/*',gulp.series('image')); 
    gulp.watch('dist/unique/*.html', browserSync.reload); 
    gulp.watch('dist/js/**/*.js', browserSync.reload); 
    gulp.watch('dist/css/**/*.scss', browserSync.reload); 
})

gulp.task('makeAll', gulp.series('sass', 'twig', 'babel', 'image'));