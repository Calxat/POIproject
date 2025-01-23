function sudoku_gui()
    fig = uifigure('Name', 'Sudoku', 'Position', [100 100 400 450]);
    
    newGameButton = uibutton(fig, 'Position', [150 400 100 40], 'Text', 'Nowa gra','ButtonPushedFcn', @(btn,event)newGame());
    difficulty = uidropdown(fig,'Position', [150 300 100 40],"Items",["Łatwy","Średni","Trudny"]);
    timeLabel = uilabel(fig, 'Position', [280 50 100 40], 'Text', 'Czas: 0:00', 'Visible','off');
    
    t = timer('ExecutionMode', 'fixedRate', 'Period', 1, 'TimerFcn', @updateTimer);
    startTime = [];

    initial_board = [
        8 0 3 0 0 5 6 0 0;
        6 2 0 9 4 8 5 0 3;
        0 0 0 6 0 0 0 0 2;
        0 7 0 0 0 3 4 6 0;
        0 0 9 7 0 0 0 8 0;
        2 4 8 0 0 9 7 0 5;
        0 5 1 0 0 0 0 0 0;
        0 8 2 0 1 6 3 0 7;
        0 0 6 0 9 0 0 5 8];

    board = gobjects(9, 9);
    matrix = initial_board;

    function newGame()
    newGameButton.Visible = false;
    timeLabel.Visible = true;
    difficulty.Visible = false;
    startTime = tic;
    
        for i = 1:9
            for j = 1:9
                board(i, j) = uieditfield(fig, 'text', 'Position', [(j-1)*40+20 (10-i)*40+50 40 40],'ValueChangedFcn', @(src,event)updateBoard(src,i,j));
                board(i, j).Value = '';
                if initial_board(i, j) ~= 0
                        board(i, j).Value = num2str(initial_board(i, j));
                        board(i, j).Editable = 'off';
                        board(i, j).BackgroundColor = '#d8e0ed';
                        board(i,j).HorizontalAlignment = 'center';
                    else
                        board(i, j).Value = '';
                        board(i, j).Editable = 'on';
                        board(i, j).BackgroundColor = 'white';
                        board(i,j).HorizontalAlignment = 'center';
                end
            end
        end
    end
    

    start(t);
    
    function updateTimer(~, ~)
        if isempty(startTime)
            startTime = tic;
        end
        elapsedTime = round(toc(startTime));
        minutes = floor(elapsedTime / 60);
        seconds = mod(elapsedTime, 60);
        timeLabel.Text = sprintf('Czas: %d:%02d', minutes, seconds);
    end
    
    function updateBoard(src, row, col)
        if isempty(src.Value)
            matrix(row, col) = 0;
        else
            matrix(row, col) = str2double(src.Value);
        end
        validateBoard();
    end

    function validateBoard()
        for i = 1:9
            for j = 1:9
                if matrix(i, j) ~= 0 && (isDuplicateRow(i, j) || isDuplicateColumn(i, j) || isDuplicateBox(i, j))
                    board(i, j).BackgroundColor = 'red';
                else
                    board(i, j).BackgroundColor = 'white';
                    if initial_board(i, j) ~= 0
                        board(i, j).BackgroundColor = '#d8e0ed';
                    end
                    if all(matrix(:) ~= 0)
                        uialert(fig, 'Icon', 'success','Wynik', 'Rozwiązano sudoku!');
                        stop(t);
                        return;
                    end
                end
            end
        end 
    end

    function duplicate = isDuplicateRow(row, col)
        duplicate = false;
        value = matrix(row, col);
        if sum(matrix(row, :) == value) > 1
            duplicate = true;
        end
    end

    function duplicate = isDuplicateColumn(row, col)
        duplicate = false;
        value = matrix(row, col);
        if sum(matrix(:, col) == value) > 1
            duplicate = true;
        end
    end

    function duplicate = isDuplicateBox(row, col)
        duplicate = false;
        value = matrix(row, col);
        rowStart = 3 * floor((row - 1) / 3) + 1;
        colStart = 3 * floor((col - 1) / 3) + 1;
        box = matrix(rowStart:rowStart+2, colStart:colStart+2);
        if sum(box(:) == value) > 1
            duplicate = true;
        end
    end
end