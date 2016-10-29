
class Sox

  attr_accessor :program_name, :author, :files

  NL3 = "\\n\\n\\n"

  CMDS = {
    "preliminary custom command(s)" => "If selected, you'll be prompted to enter code to be executed first.",
    "trim leading silence" => "Trim beginning file until above a threshold you'll set.",
    "trim trailing silence" => "Trim end of file when below a threshold you'll set.",
    "ending custom command(s)" => "If selected, you'll be prompted to enter code to be executed last.",
  }

  def initialize program_name = "SoXBot", author = "Jeff Russ"
    @program_name = program_name
    @author = author
    @PG_HEAD = "<big><b>#{@program_name}</b></big> by #{author}#{NL3}"
    @files = {}
    @commands = []
  end

  def Sox.get_max_amp file
    %x(max="$(sox #{file} -n stat 2>&1 | grep "^Maximum amplitude")"; \
      echo "${max##* }").tr("\n","")
  end
  def Sox.get_duration file
    %x(dur=$(soxi -d #{file}) && echo "$dur" || echo "fail").tr("\n","")
  end
  def Sox.get_num_chan file
    %x(echo $(soxi -c #{file})).tr("\n","")
  end
  def Sox.get_samplerate file
    %x(echo $(soxi -r #{file})).tr("\n","")
  end
  def Sox.get_bit_depth file
    %x(echo $(soxi -b #{file})).tr("\n","")
  end
  def Sox.get_filetype file
    %x(echo $(soxi -t #{file})).tr("\n","")
  end
  def Sox.get_encoding file
    %x(echo $(soxi -e #{file})).tr("\n","")
  end
  def Sox.get_comments file
    %x(echo $(soxi -a #{file})).tr("\n"," ")
  end
  def Sox.soxi_verbose file
    %x(soxi -V #{file} 2>&1)
  end

  def files_selector_prompt files
    file_count = 0
    non_count = 0
    cols = Params.new([
      "--column", "Apply",
      "--column", "File",
      "--column", "Duration",
      "--column", "Ch.",
      "--column", "Rate",
      "--column", "Bits",
      "--column", "Max ampli.",
      "--column", "Loop?",
      "--column", "MIDI?",
      "--column", "Type",
      "--column", "Encoding",
      "--column", "Comments",
      ]);

    file_list = Params.new()

    files.each do|file|
      dur = Sox.get_duration file
      if dur == 'fail'
        @files[file] = { use: false, valid: false }
        non_count += 1
      else
        @files[file] = { use: true, valid: true, duration: dur }
        file_list << "true"
        file_list << "#{file}"
        file_list << "#{dur}"
        @files[file][:channels] = Sox.get_num_chan file
        file_list << @files[file][:channels]
        @files[file][:samplerate] = Sox.get_samplerate file
        file_list << @files[file][:samplerate]
        @files[file][:bit_depth] = Sox.get_bit_depth file
        file_list << @files[file][:bit_depth] 
        @files[file][:max_amp] = Sox.get_max_amp file
        file_list << @files[file][:max_amp]
        full_info = Sox.soxi_verbose file
        if full_info =~ /loop/i
          @files[file][:has_loop] = true
          file_list << "yes"
        else
          @files[file][:has_loop] = false
          file_list << "no"
        end
        if full_info =~ /midi/i
          @files[file][:has_midi] = true
          file_list << "yes"
        else
          @files[file][:has_midi] = false
          file_list << "no"
        end
        @files[file][:filetype] = Sox.get_filetype file
        file_list << @files[file][:filetype]
        @files[file][:encoding] = Sox.get_encoding file
        file_list << @files[file][:encoding]
        @files[file][:comments] = Sox.get_comments file
        file_list << @files[file][:comments]

        file_count += 1
      end
    end

    count_msg = "#{file_count} soundfiles found (#{non_count} ignored).#{NL3}"

    height = file_count * 22 + 200

    zenity_checklist = Params.new([
      "zenity", 
      "--list", "--checklist", "--width=1000", "--height=#{height}",
      "--title", "#{@program_name}",
      "--text", "#{@PG_HEAD}#{count_msg}<big>Confirm which files you'd like to effect:</big>",
    ])

    use = %x(#{zenity_checklist} #{cols} #{file_list}).split("|")

    @files.each do |file, hash|
      unless use.include? file
        @files[file][:use] = false
      end
    end

    return use
  end

  def Sox.prepare_output src_file, des_file=false
    # %x(cp "#{src_file}" "sox_tmp_#{src_file}")
    unless des_file 
      %x(cp "#{src_file}" "#{src_file}.bak")
    else
      %x(cp "#{src_file}" "#{des_file}")
    end
  end

  def Sox.reverse_file file
    %x(sox "#{file}" "sox_tmp_#{file}" reverse; cp "sox_tmp_#{file}" "#{file}")
  end
  
  def Sox.strip_leading_silence file, thres="0.15%"
    # the threshold: could be something like "-40d" or "0.15%""
    %x(sox "#{file}" "sox_tmp_#{file}" silence 1 0 "#{thres}"; cp "sox_tmp_#{file}" "#{file}")
  end

  def Sox.strip_trailing_silence file, thres="0.15%"
    # the threshold: could be something like "-40d" or "0.15%""
    Sox.reverse_file file
    Sox.strip_leading_silence file thres
    Sox.reverse_file file
  end

  def commands_selector_prompt

    cols = Params.new([
      "--column", "Run",
      "--column", "Command",
      "--column", "Description",
      ]);

    cmd_list = Params.new()

    CMDS.each do |cmd_name, descr|
      cmd_list << "true"
      cmd_list << cmd_name
      cmd_list << descr
    end

    height = CMDS.length * 22 + 200

    zenity_checklist = Params.new([
      "zenity", 
      "--list", "--checklist", "--width=1000", "--height=#{height}",
      "--title", "#{@program_name}",
      "--text", "#{@PG_HEAD}<big>Confirm which commands (in this set order) you'd like to run.</big>",
    ])

    @commands = %x(#{zenity_checklist} #{cols} #{cmd_list}).split("|")
    return @commands
  end

end


