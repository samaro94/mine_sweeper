class ApiController < ApplicationController
    before_action :get_mines_map

    def solution
        solve_mines_map
        render json: {
            problem: @problem,
            solution: @solution
        }
    end

    private

    def get_mines_map
        response = HTTParty.get(
            "https://mine-sweeper-generator.herokuapp.com/solver",
            headers: {
                'Content-Type' => "application/json"
            }
        )
        @problem = JSON.parse(response.parsed_response) if !response.blank? && response.code == 200
    end

    def solve_mines_map
        return if @problem.blank?
        @solution = Marshal.load(Marshal.dump(@problem))
        for i in 0..@problem.size-1 do
            for j in 0..@problem.first.size-1 do
                if @problem[i][j].blank?
                    mines = []
                    mines.push(@problem[i-1][j-1])
                    mines.push(@problem[i-1][j])
                    mines.push(@problem[i-1][j+1])
                    mines.push(@problem[i][j-1])
                    mines.push(@problem[i][j+1])
                    mines.push(@problem[i+1][j-1])
                    mines.push(@problem[i+1][j])
                    mines.push(@problem[i+1][j+1])
                    @solution[i][j] = mines.count{|x| x == "*"}
                end
            end
        end
    end

end
