# Sonesthesia

Sonesthesia (sonification + synesthesia) is a tool to generate music, but also an experimental idea: _can we use music to help us remember what we last did on a project?_

Coding, writing, and other deep work is done in a state of flow where we build up mental models. It would be neat if we could use music to help us reload that mental state.


## What's in the repo?

sonify.rb is a Ruby script that uses [Midicraft](https://github.com/mattdiamond/MidiCraft) to generate a short MIDI file based on a hash of a commit.

If you don't want to use with a commit hash, the script can use a text string you provide and generate a hash for you.

In short, how it works:

 - Input is or becoems a SHA1 hash
 - SHA1 hash is converted to a string of hex digits
 - Hex digits are converted to an array and mapped to notes
 - We build a MIDI file with the notes and durations


## Install / prerequisites

- Ruby
- Midi player (e.g. timidity)
- Midicraft gem


## Usage examples

Using sonify.rb to generate music for the current commit

```
ruby sonify.rb $(git rev-parse HEAD)
```

Using sonify.rb to generate music for a text string, specifying the output file

```
ruby sonify.rb -t "I'm writing a README.md file" -o "readme.mid"
```


## Future work

Things we'd like to do with the project. Not necessarily in the order of priority. Experimentation and contributions are welcome.

### Housekeeping improvements

- Validation of input
- Gemfile
- Tests

### Configuration improvements

More configuration options for the script e.g. palette, duration, etc.

### Musical improvements

Anything to improve the range and musicality of the generated music.

- Multiple tracks
- Channel/instrument flags
- Map duration to velocity or pitch bend

### Workflow and use examples

Create a bank of scripts or workflow examples that employ sonesthesia in interesting ways. If not in here, perhaps links out to other repos or blog posts. E.g.

- git hook sample (post-commit → play or save commit-<short>.mid)
- CI artifact: "build music for this release tag"

### Experiments

Does it actually work? To explore, implement some sort of psycology informed study, and we can track results.

### Other ideas

Anything else that doesn't fit into the other categories... hypotheses and concepts are welcome too. Those can be discussed in the issues.
