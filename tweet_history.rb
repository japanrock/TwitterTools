class TweetHistory
  def initialize
    @tweet_histories = []

    File.open(File.dirname(__FILE__) + '/tweet_history') do |file|
      while line = file.gets
       @tweet_histories << line.chomp
      end
    end
  end

  # tweet_history�ե�����˥���ȥ꡼ID��񤭹���
  def write(entry_id)
    tweet_history = File.open(File.dirname(__FILE__) + '/tweet_history', 'a+')
    tweet_history.puts entry_id
    tweet_history.close
  end

  # ���˥ݥ��Ȥ�������ȥ꡼ID�����ǧ����
  def past_in_the_tweet?(entry_id)
    @tweet_histories.each do |tweet_history|
       return true if tweet_history == entry_id
    end

    false
  end

  def maintenance
    tweet_histories = []

    File.open(File.dirname(__FILE__) + '/tweet_history') do |file|
      while line = file.gets
       tweet_histories << line.chomp
      end
    end
    
    if tweet_histories.size > stay_history_count
      # �ݻ���������Τߤ�����˼���
      stay_tweet_histories = []
      stay_number = stay_history_count

      tweet_histories.reverse!.each_with_index do |history, index|
        if index <= stay_history_count
          stay_number = stay_number - 1
          stay_tweet_histories << history
        end
      end

      # File Reset
      tweet_history = File.open(File.dirname(__FILE__) + '/tweet_history', 'w')
      tweet_history.print ''
      tweet_history.close
      
      # �ǿ��Σ����ԤΤ���¸
      tweet_history = File.open(File.dirname(__FILE__) + '/tweet_history', 'a+')

      stay_tweet_histories.reverse!.each do |history|
        tweet_history.puts history
      end

      tweet_history.close
    end
  end

  private

  # default
  def stay_history_count
    100
  end
end
