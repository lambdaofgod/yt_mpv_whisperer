import fire


def change_line_to_vtt(whisper_line, i):
    line_elems = whisper_line.split("]")
    timestamp = line_elems[0].replace("[", "")
    text = line_elems[1].strip()
    return "\n".join([str(i), timestamp, text])


def write_vtt_lines(lines, f):
    f.write("WEBVTT\n\n")
    for line in lines:
        f.write(line)
        f.write("\n\n")


def change_lines_to_vtt(whisper_filename, out_filename):
    with open(whisper_filename, "r") as f:
        new_lines = (
            change_line_to_vtt(line, i + 1) for (i, line) in enumerate(f.readlines())
        )
    with open(out_filename, "w") as f:
        write_vtt_lines(new_lines, f)


if __name__ == "__main__":
    fire.Fire(change_lines_to_vtt)
