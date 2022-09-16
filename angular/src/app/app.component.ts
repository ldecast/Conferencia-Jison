import { Component } from '@angular/core';
import { AppService } from './app.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(private appService: AppService) { }

  EditorOptions = {
    theme: "vs-dark",
    automaticLayout: true,
    scrollBeyondLastLine: false,
    fontSize: 16,
    minimap: {
      enabled: true
    },
    language: 'javascript'
  }

  ConsoleOptions = {
    theme: "vs-dark",
    readOnly: true,
    automaticLayout: true,
    scrollBeyondLastLine: false,
    fontSize: 16,
    minimap: {
      enabled: true
    },
    language: ''
  }

  title = 'jison';
  entrada: string = '';
  salida: string = '';

  onSubmit() {
    if (this.entrada != "") {
      const x = { "input": this.entrada }
      this.appService.compile(x).subscribe(
        data => {
          console.log('Data received!', data.output);
          this.salida = String(data.output);
        },
        error => {
          console.log('There was an error :(', error);
          this.salida = error.error || "Ocurrió un error.\nIngrese otra entrada."
        }
      );
    } else
      this.salida = "Entrada vacía. Intente de nuevo.";
  }

}
