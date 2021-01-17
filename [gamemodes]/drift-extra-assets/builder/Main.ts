import * as filesystem from 'fs-extra';

import * as fs from 'fs';
import * as path from 'path';

export class Files {

    public readonly directory: string = "../src/";

    public readonly filename: string = "NativeUIReloaded.lua";


    public onInit = (): void => {
        filesystem.exists(`${this.directory}${this.filename}`, (exists) => {
            if (exists)
                filesystem.remove(`${this.directory}${this.filename}`, () => console.log("File deleted successfully, Start generate process."));
            else
                console.log("File not exists")
        });
        filesystem.ensureFile(`${this.directory}${this.filename}`).then(() => {
            console.info('Create file successfully : ' + `${this.directory}${this.filename}`);
            this.onBuild();
        }).catch(error => {
            console.error(error);
        });
    };

    public onBuild = (): void => {
        // https://stackoverflow.com/questions/5827612/node-js-fs-readdir-recursive-directory-search
        let fetching = function (dir, done) {
            let results = [];
            filesystem.readdir(dir, function (err, list) {
                if (err) return done(err);
                let pending = list.length;
                if (!pending) return done(null, results);
                list.forEach(function (file) {
                    file = path.resolve(dir, file);
                    fs.stat(file, function (err, stat) {
                        if (stat && stat.isDirectory()) {
                            fetching(file, function (err, res) {
                                results = results.concat(res);
                                if (!--pending) done(null, results);
                            });
                        } else {
                            results.push(file);
                            if (!--pending) done(null, results);
                        }
                    });
                });
            });
        };
        fetching(`${this.directory}`, function (err, results) {
            if (err) throw err;
            results.forEach(function (x) {
                fs.readFile(x, 'utf8', function (err, contents) {
                    filesystem.appendFile("../src/NativeUIReloaded.lua", contents, (error) => {
                        if (error)
                            console.error("can't update file ../src/NativeUIReloaded.lua");
                    });
                });
            });
        });
    };
}

new Files().onInit();