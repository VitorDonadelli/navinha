Player = Object:extend()
Bullet:implement()


function Player:new()

    --==GAMEPLAY==--
    
    --Posição e Tamanho--
    self.x = love.graphics.getWidth()/2
    self.y = (love.graphics.getHeight()/3)*2
    self.width = 50
    self.height = 50
    self.teste = 0
    
    --Velocidade e força do tiro
    self.shootRate = 6
    self.shootSpeed = 750
    self.shootDamage = 1
    self.shootTimer = 0
    self.bullet = {}

    --Atributos do player
    self.health = 10
    self.originalSpeed = 100
    self.speed = 300

end

function Player:movement(dt)
   --Movimentação
    if love.keyboard.isDown('up') then
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isDown('down') then
        self.y = self.y + (self.speed * dt)
    end
    if love.keyboard.isDown('left') then
        self.x = self.x - (self.speed * dt)
    end
    if love.keyboard.isDown('right') then
        self.x = self.x + (self.speed * dt)
    end
   --

   --Limites
    if self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
    end
    if self.x < 0 then
        self.x = 0
    end
    if self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
    if self.y < 0 then
        self.y = 0
    end
   --
end

function Player:shoot()
    self.shootTimer = self.shootRate --reinicia o timer do fire rate
    table.insert(self.bullet,Bullet(self)) -- instancia mais uma bala na table
    
end

function Player:update(dt)
    self:movement(dt)
    
    if love.keyboard.isDown('z') then
            if self.shootTimer <= 0 then --se o timer estiver zerado, poderá chamar shoot()
                self:shoot()
            end
    end
    

    
   --Timer da bala
    if self.shootTimer > 0 then
        self.shootTimer = self.shootTimer - (10*dt)
        if self.shootTimer < 0 then --se o timer for menor que zero, recebe 0 
            self.shootTimer = 0
        end
    end
   -------
    --i é o indice, blt é o objeto no indice i da table self.bullet
    --esse for vai até a ultima posição != nil da table self.bullet
    for i, blt in pairs(self.bullet) do 
        blt:update(dt)  --atualizar todas as balas instanciadas
        if blt.y < 0 then   --se a bala passar da tela por cima, a bala da posição i da table self.bullet será removida
            table.remove(self.bullet,i) --do que eu percebi, esse for pula automaticamente as posições que são nil, achei topster
        end
    end
    

end

function Player:draw()  
    --um triangulo mega placeholder
    love.graphics.polygon("line",self.x,    self.y+self.height,  self.x+(self.width/2),  self.y,   self.x+self.width,self.y+self.height)

    for i, blt in pairs(self.bullet) do
        blt:draw() --desenhar cada bala instanciada
    end
end
        