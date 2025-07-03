import re

from operator import itemgetter

def append_matches(accum, results, group):
    for match in results:
        captured = (
            match.start(group),
            match.end(group),
            match.group(group)
        )
        accum.append(captured)

def mark(text, args, Mark, extra_cli_args, *a):
    matches = []

    aws_arn_pattern='arn:aws:.*:.*:(.+?):([-a-zA-Z0-9]+?(?:[^-a-zA-Z0-9]|$))+'
    for arn_match in re.finditer(aws_arn_pattern, text):
        matches.append((arn_match.start(2), arn_match.end(2), arn_match.group(2)))

    tf_resource_pattern='# ([-_.\w]+) will be (updated|destroyed|created)'
    for tf_match in re.finditer(tf_resource_pattern, text):
        matches.append((tf_match.start(1), tf_match.end(1), tf_match.group(1)))

    # eol_pattern = re.Pattern('[\r\n]+')
    git_pattern='git push --set-upstream ([-\w]+) ([-\w]+)'
    git_match = re.search(git_pattern, text)
    if git_match:
        matches.append((git_match.start(), git_match.end(), git_match.group(0)))

    git_merge_conflict_pattern = 'both modified:\s+([-_/.\w]+)'
    append_matches(matches, re.finditer(git_merge_conflict_pattern, text), 1)

    for (idx, (start, end, text)) in enumerate(sorted(matches, key=itemgetter(0))):
        yield Mark(idx, start, end, text, {})
