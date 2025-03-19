#!/bin/bash

# Define colors for the menu
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to display the menu with colors and ASCII art
show_menu() {
    clear
    echo -e "${CYAN}"
    echo "   _____ ____  _     ____  ____  _____ "
    echo "  /    //  _ \\/ \   /  _ \/ ___\/  __/ "
    echo "  |  __\| / \|| |   | / \||    \|  \   "
    echo "  | |   | \_/|| |_/\| |-||\___ ||  /_  "
    echo "  \_/   \____/\____/\_/ \|\____/\____\ "
    echo -e "${RESET}"
    echo -e "${YELLOW}=================================================${RESET}"
    echo -e "${WHITE}${BOLD}           HTML Color Theme Changer                ${RESET}"
    echo -e "${YELLOW}=================================================${RESET}"
    echo -e "${BOLD}Select a color theme to apply:${RESET}"
    echo -e "${BLUE}1. Blue Theme ${RESET}(#2d709f)"
    echo -e "${GREEN}2. Sage Green Theme ${RESET}(#89a49e)"
    echo -e "${GREEN}3. Forest Green Theme ${RESET}(#3b591e)"
    echo -e "${PURPLE}4. Slate Gray Theme ${RESET}(#575e6c)"
    echo -e "${RED}5. Coral Red Theme ${RESET}(#d8675b)"
    echo -e "${YELLOW}6. Exit${RESET}"
    echo -e "${YELLOW}=================================================${RESET}"
    echo -e -n "${BOLD}Enter your choice [1-6]: ${RESET}"
}

# Function to generate a unique filename that doesn't overwrite existing files
generate_filename() {
    local original_file="$1"
    local base_name="${original_file%.*}"
    local extension="${original_file##*.}"
    local new_file="${base_name}-v1.${extension}"
    local counter=1

    while [ -f "$new_file" ]; do
        counter=$((counter + 1))
        new_file="${base_name}-v${counter}.${extension}"
    done

    echo "$new_file"
}

# Function to apply the selected color theme
apply_theme() {
    local input_file="$1"
    local output_file="$2"
    local theme="$3"

    # Define the original colors to replace
    local main_color="#4a6149"
    local darker_color="#3d503c"
    local bg_color1="#f5f5f5"
    local bg_color2="#e0e5e0"
    local text_color="#44484b"
    local secondary_text="#5f6469"

    # Set theme colors based on selection
    case $theme in
        1) # Blue Theme
            local new_main="#2d709f"
            local new_darker="#1c5985"
            local new_bg1="#f0f5f9"
            local new_bg2="#d9e6f2"
            local new_text="#2c3e50"
            local new_secondary="#5d6d7e"
            ;;
        2) # Sage Green Theme
            local new_main="#89a49e"
            local new_darker="#6b8984"
            local new_bg1="#f5f7f5"
            local new_bg2="#e6ebe7"
            local new_text="#3e4a47"
            local new_secondary="#5f6b68"
            ;;
        3) # Forest Green Theme
            local new_main="#3b591e"
            local new_darker="#2a4215"
            local new_bg1="#f2f5ed"
            local new_bg2="#e1e8d8"
            local new_text="#2c3c14"
            local new_secondary="#4e5a3e"
            ;;
        4) # Slate Gray Theme
            local new_main="#575e6c"
            local new_darker="#3f4450"
            local new_bg1="#f2f3f5"
            local new_bg2="#dfe0e6"
            local new_text="#30343e"
            local new_secondary="#5c6173"
            ;;
        5) # Coral Red Theme
            local new_main="#d8675b"
            local new_darker="#c44c3f"
            local new_bg1="#faf2f1"
            local new_bg2="#f8e0de"
            local new_text="#5e3631"
            local new_secondary="#7d5652"
            ;;
    esac

    # Create a copy of the file
    cp "$input_file" "$output_file"

    # Replace colors in the file
    sed -i "s/$main_color/$new_main/g" "$output_file"
    sed -i "s/$darker_color/$new_darker/g" "$output_file"
    
    # Replace background gradient colors (need to handle the linear-gradient format)
    sed -i "s/linear-gradient(135deg, $bg_color1 0%, $bg_color2 100%)/linear-gradient(135deg, $new_bg1 0%, $new_bg2 100%)/g" "$output_file"
    
    # For fallback background colors and other instances
    sed -i "s/$bg_color1/$new_bg1/g" "$output_file"
    sed -i "s/$bg_color2/$new_bg2/g" "$output_file"
    
    # Replace text colors
    sed -i "s/$text_color/$new_text/g" "$output_file"
    sed -i "s/$secondary_text/$new_secondary/g" "$output_file"

    echo -e "${GREEN}Theme applied successfully!${RESET} New file created: ${BOLD}$output_file${RESET}"
}

# Main function
main() {
    local input_file=""
    
    # Check if a file is provided as an argument
    if [ $# -eq 0 ]; then
        echo -e "${RED}Please provide an HTML file to modify.${RESET}"
        echo -e "Usage: ${BOLD}$0 <filename.html>${RESET}"
        exit 1
    else
        input_file="$1"
        
        # Check if the file exists
        if [ ! -f "$input_file" ]; then
            echo -e "${RED}Error: File '$input_file' not found.${RESET}"
            exit 1
        fi
        
        # Check if the file is an HTML file
        if [[ "$input_file" != *.html && "$input_file" != *.htm ]]; then
            echo -e "${YELLOW}Warning: The file doesn't appear to be an HTML file.${RESET}"
            echo -e "Continue anyway? ${BOLD}(y/n)${RESET}"
            read -r response
            if [[ "$response" != "y" && "$response" != "Y" ]]; then
                echo -e "${YELLOW}Operation cancelled.${RESET}"
                exit 0
            fi
        fi
    fi
    
    # Show menu and get user choice
    show_menu
    read -r choice
    
    # Process user choice
    case $choice in
        1|2|3|4|5)
            output_file=$(generate_filename "$input_file")
            apply_theme "$input_file" "$output_file" "$choice"
            ;;
        6)
            echo -e "${CYAN}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${RESET}"
            sleep 2
            main "$input_file"
            ;;
    esac
}

# Start the script
main "$@"