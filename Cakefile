fs = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'
{log, error} = console; print = log

run = (name, args...) ->
    proc = spawn(name, args)
    proc.stdout.on('data', (buffer) -> print buffer if buffer = buffer.toString().trim())
    proc.stderr.on('data', (buffer) -> error buffer if buffer = buffer.toString().trim())
    proc.on('exit', (status) -> process.exit(1) if status isnt 0)

shell = (cmds, callback) ->
    cmds = [cmds] if Object::toString.apply(cmds) isnt '[object Array]'
    exec(cmds.join(' && '), (err, stdout, stderr) ->
        print trimStdout if trimStdout = stdout.trim()
        error stderr.trim() if err
        callback() if callback
    )

walk = (dir, pattern, done) ->
  results = []
  fs.readdir dir, (err, list) ->
    return done(err, []) if err
    pending = list.length
    return done(null, results) unless pending
    for name in list
      file = "#{dir}/#{name}"
      try
        stat = fs.statSync file
      catch err
        stat = null

      if stat?.isDirectory() 
        walk file, pattern, (err, res) ->
          for name in res
            if(pattern.test(name))
              results.push name 
          done(null, results) unless --pending
      else
        if(/.spec.js/.test(file))
          results.push file
        done(null, results) unless --pending

task 'watch', 'Run middleman and the file watcher', ->
  run 'coffee', '-wco', './lib', './src'