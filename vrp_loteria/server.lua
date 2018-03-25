-- ###################################
--
--       Credits: Sighmir and Shadow
--
-- ###################################
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPlt = {}
Tunnel.bindInterface("vrp_loteria",vRPlt)

function vRPlt.buyTickets(amount)
  local user_id = vRP.getUserId(source) .. "" -- pega user_id como string
  local player = vRP.getUserSource(tonumber(user_id))
  local tickets = json.decode(vRP.getSData("lotto:tickets")) -- pega tickets do banco
  if not tickets then tickets = {} end -- caso tickets nao exista ainda cria
  if not tickets[user_id] then tickets[user_id] = {} end -- verifica se o usuario ja tem algum ticket, se nao tiver, cria
  if ((#tickets[user_id])+amount) <= 5 then -- verifica se chegou ou limite de tickets (tickets atuais + quantidade comprada)
    if vRP.tryPayment(tonumber(user_id),500*amount) then -- verifica o pagamento 100*quantidade comprada
      local money = json.decode(vRP.getSData("lotto:money")) -- pega money do banco
	  TriggerClientEvent("chatMessage", player, "[Loteria]", {255, 255, 0}, "Você comprou: " .. amount .. " ticket(s)")
      if not money then money = 0 end -- se nao tiver money cria
      vRP.setSData("lotto:money",json.encode(money+(500*amount))) -- registra money + 100*quantidade comprada no banco
      for i=1,amount do 
        table.insert(tickets[user_id], math.random(1000,9999)) -- insere a quantidade de tickets comprados pra esse usuario com valor de 1000 a 9999 pra ter 4 numeros
      end
      vRP.setSData("lotto:tickets",json.encode(tickets)) -- salva de novo todos os tickets no banco
	else
	  TriggerClientEvent("chatMessage", player, "[Loteria]", {255, 255, 0}, "Você não tem dinheiro suficiente!")
    end
  else
    TriggerClientEvent("chatMessage", player, "[Loteria]", {255, 255, 0}, "Você já alcançou o número máximo de tickets")
  end
end


function tick_lotto()
  local old_time = json.decode(vRP.getSData("lotto:time")) -- pega segundos da ultima vez que executou
  if not old_time then old_time = 0 end -- checa se existe tempo, se nao existir, cria
  
  local randomMsg = {	
		"Faltam " .. math.ceil(30-((os.time() - old_time )/60)) .." minutos para terminar essa loteria!",
     	"Não esqueça de comprar seu ticket!",
    	"Não perca essa, venha comprar seu ticket por apenas ^2R$500",
	}
  
  if (os.time() - old_time > (30*60)) then -- checa se passou 30 vezes 60 segundos, 30 minutos
    local no_winner = true -- nao tem nenhum ganhador no inicio
    local winner = math.random(1000,9999) -- pega o numero ganhador
    local tickets = json.decode(vRP.getSData("lotto:tickets")) -- pega tickets da lotto
    if not tickets then tickets = {} end -- caso tickets nao exista ainda cria
    local money = json.decode(vRP.getSData("lotto:money")) -- pega dineiro acomulado
    if not money then money = 0 end -- se nao tiver money cria
    for user_id,u_tickets in pairs(tickets) do -- para user_id e u_tickets (tickets do usuario)
       for i,ticket in pairs(u_tickets) do -- para ticket de u_tickets (tickets do usuario)
         if no_winner and ticket == winner then -- encontra ganhador se ninguem ganhou
           vRP.setBankMoney(tonumber(user_id),money) -- da o dinheiro ao ganhador
           vRP.setSData("lotto:money", json.encode(0)) -- volta o dinheiro da lotto pra 0
           local identity = vRP.getUserIdentity(tonumber(user_id)) -- pega identidade do ganhador
           TriggerClientEvent("chatMessage", -1, "[Loteria]", {255, 255, 0}, "E o ganhador da Loteria foi: ^2" .. identity.name .. " " .. identity.firstname .. "^0 | Ticket Sorteado: ^2" ..winner.. "^0 | Premiação: ^2R$" ..money)
           no_winner = false -- nenhum ganhador = false
         end
       end
    end
    if no_winner then -- se nenhum ganhador
     TriggerClientEvent("chatMessage", -1, "[Loteria]", {255, 255, 0}, "A loteria já está acumulada em: ^2R$" ..money)
    end
    vRP.setSData("lotto:time",json.encode(os.time())) -- salva o tempo que a lotto foi executada no banco
  end 
  TriggerClientEvent("chatMessage", -1, "[Loteria]", {255, 255, 0}, randomMsg[math.random(1,#randomMsg)])
  vRP.setSData("lotto:tickets",json.encode({})) -- limpa tickets
end
Citizen.CreateThread(function()
  while true do
    Wait(60000*5) -- intervalo entre as mensagens da lotto e o check do tempo
    tick_lotto() -- roda a loto no server start
  end
end)
