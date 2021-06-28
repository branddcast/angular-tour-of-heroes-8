import { Component } from '@angular/core';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'angular-tour-of-heroes8';
  host = environment.host;
  api = environment.api;
  env = environment.env;
  user = environment.user;
  username = environment.username;
  data = JSON.stringify(environment);
}
