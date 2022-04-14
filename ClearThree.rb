=begin
制作更原创的RPG内容的时候，需要这个脚本。
网上不好找，因为太简单。
我做这个不够精简，将就用，懒得删东西。
=end
##1.window kill ：去掉金钱和右侧主角团队状态栏
#==============================================================================
# ** Scene_Menu   修改 by:洮羱芝闇
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_gold_window
    create_status_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Gold Window
  #--------------------------------------------------------------------------
  def create_gold_window
    # @gold_window = Window_Gold.new
    # @gold_window.x = 0
    # @gold_window.y = Graphics.height - @gold_window.height
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    # status_window = Window_MenuStatus.new(@command_window.width, 0)
  end
  #--------------------------------------------------------------------------
  # * [Item] Command
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item)
  end
  #--------------------------------------------------------------------------
  # * [Skill], [Equipment] and [Status] Commands
  #--------------------------------------------------------------------------
  def command_personal
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_personal_ok))
    @status_window.set_handler(:cancel, method(:on_personal_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Formation] Command
  #--------------------------------------------------------------------------
  def command_formation
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_formation_ok))
    @status_window.set_handler(:cancel, method(:on_formation_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Save] Command
  #--------------------------------------------------------------------------
  def command_save
    SceneManager.call(Scene_Save)
  end
  #--------------------------------------------------------------------------
  # * [Exit Game] Command
  #--------------------------------------------------------------------------
  def command_game_end
    SceneManager.call(Scene_End)
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_ok
    case @command_window.current_symbol
    when :skill
      SceneManager.call(Scene_Skill)
    when :equip
      SceneManager.call(Scene_Equip)
    when :status
      SceneManager.call(Scene_Status)
    end
  end
  #--------------------------------------------------------------------------
  # * [Cancel] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_cancel
    @status_window.unselect
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [OK]
  #--------------------------------------------------------------------------
  def on_formation_ok
    if @status_window.pending_index >= 0
      $game_party.swap_order(@status_window.index,
                             @status_window.pending_index)
      @status_window.pending_index = -1
      @status_window.redraw_item(@status_window.index)
    else
      @status_window.pending_index = @status_window.index
    end
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [Cancel]
  #--------------------------------------------------------------------------
  def on_formation_cancel
    if @status_window.pending_index >= 0
      @status_window.pending_index = -1
      @status_window.activate
    else
      @status_window.unselect
      @command_window.activate
    end
  end
end
##2.command kill去掉除了退出和道具以外的所有选项
#==============================================================================
# ** Window_MenuCommand  修改 by:洮羱芝闇
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Initialize Command Selection Position (Class Method)
  #--------------------------------------------------------------------------
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    select_last
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
    #add_formation_command
    #add_original_commands
    #add_save_command
    add_game_end_command
  end
  #--------------------------------------------------------------------------
  # * Add Main Commands to List
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command(Vocab::item,   :item,   main_commands_enabled)
    #add_command(Vocab::skill,  :skill,  main_commands_enabled)
    #add_command(Vocab::equip,  :equip,  main_commands_enabled)
    #add_command(Vocab::status, :status, main_commands_enabled)
  end
  #--------------------------------------------------------------------------
  # * Add Formation to Command List
  #--------------------------------------------------------------------------
  def add_formation_command
    
    #add_command(Vocab::formation, :formation, formation_enabled)
    
  end
  #--------------------------------------------------------------------------
  # * For Adding Original Commands
  #--------------------------------------------------------------------------
  def add_original_commands
  end
  #--------------------------------------------------------------------------
  # * Add Save to Command List
  #--------------------------------------------------------------------------
  def add_save_command
    add_command(Vocab::save, :save, save_enabled)
  end
  #--------------------------------------------------------------------------
  # * Add Exit Game to Command List
  #--------------------------------------------------------------------------
  def add_game_end_command
    add_command(Vocab::game_end, :game_end)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Main Commands
  #--------------------------------------------------------------------------
  def main_commands_enabled
    $game_party.exists
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Formation
  #--------------------------------------------------------------------------
  def formation_enabled
    $game_party.members.size >= 2 && !$game_system.formation_disabled
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Save
  #--------------------------------------------------------------------------
  def save_enabled
    !$game_system.save_disabled
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    @@last_command_symbol = current_symbol
    super
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select_symbol(@@last_command_symbol)
  end
end
##3.statu kill：单纯去掉主角团队状态，单独使用时仍会显示右侧大窗口
#==============================================================================
# ** Window_MenuStatus       修改 by:洮羱芝闇
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :pending_index            # Pending position (for formation)
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @pending_index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 160
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_party.members.size
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2) / 4
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    # actor = $game_party.members[index]
    # enabled = $game_party.battle_members.include?(actor)
    # rect = item_rect(index)
    # draw_item_background(index)
    # draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
    # draw_actor_simple_status(actor, rect.x + 108, rect.y + line_height / 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Background for Item
  #--------------------------------------------------------------------------
  def draw_item_background(index)
    # if index == @pending_index
    #   contents.fill_rect(item_rect(index), pending_color)
    # end
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    super
    $game_party.menu_actor = $game_party.members[index]
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.menu_actor.index || 0)
  end
  #--------------------------------------------------------------------------
  # * Set Pending Position (for Formation)
  #--------------------------------------------------------------------------
  def pending_index=(index)
    last_pending_index = @pending_index
    @pending_index = index
    redraw_item(@pending_index)
    redraw_item(last_pending_index)
  end
end