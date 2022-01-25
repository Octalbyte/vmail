// Creator: nedimf (07/2020)
import os
import net.smtp

fn main() {
	//println(os.args[0])
	
	if os.args.len == 2 && os.args[1] == 'set' {
		println('Setting defaults for app')
	 	if os.exists('vmail.config') {
			if os.is_dir('vmail.config') {
				os.rmdir('vmail.config')?
			} else {
				os.rm('vmail.config')?
			}
		}

		mailserver := os.input('Default mail server: ')
		mailport := os.input('Default mail server port: ')
		username := os.input('Default username: ')

		mut f := os.create('vmail.config') or {
			println(err)
			return
		}
		f.write(mailserver.bytes())?
		f.write('\n'.bytes())?
		f.write(mailport.bytes())?
		f.write('\n'.bytes())?
		f.write(username.bytes())?
		f.close()
		println('Done!')
		exit(0)
	}
	println('V Email client')
	println('')
	mut conf := false
	mut defaults := ['','','']
	if os.exists('vmail.config') {
		defaults = os.read_lines('vmail.config')?
		conf = true
	}
	

	
	d0 := defaults[0]
	mut mailserver := os.input('Mail server ($d0) :')
	println(mailserver)
	if mailserver == '' || mailserver == '<EOF>'{
		mailserver = defaults[0]
	}
	
	d1 := defaults[1]
	mut mailprt := os.input('Mail server port ($d1) :')
	if mailprt == '' {
		mailprt = defaults[1]
	}
	mailport := mailprt.int()
	d2 := defaults[2]
	mut username := os.input('Username ($d2) :')
	if username == '' {
		username = defaults[2]
	}
	password := os.input('Password: ')
	from := os.input('From: ')
	to := os.input('To: ')
	subject := os.input('Subject: ')
	body := os.input('Body: ')

	println("
		server: $mailserver
		from: $from
		port: $mailport
		username: $username
		password: $password	
	")

		
	client_cfg := smtp.Client{
		server: mailserver
		from: from
		port: mailport
		username: username
		password: password
	}
	send_cfg := smtp.Mail{
		to: to
		subject: subject
		body_type: .html
		body: body
	}
	mut client := smtp.new_client(client_cfg) or { panic('Error configuring smtp: $err') }
	client.send(send_cfg) or { panic('Error resolving email address') }
}