# Calendar sort
Sorts iCalendar lines from an input file so it can be easily compared to other files.

    ruby sort.rb file.ics
    diff <(ruby sort.rb file1.ics) <(ruby sort.rb file2.ics)
    diff <(ruby sort.rb -u file1.ics) <(ruby sort.rb -u file2.ics)
