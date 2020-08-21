import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayer/audioplayer.dart';

void main() {
  runApp(MaterialApp(
    home: Ipod(),
  ));
}
class Ipod extends StatefulWidget {
  Ipod({Key key}) : super(key: key);

  _Ipod createState() => _Ipod();
}

class _Ipod extends State<Ipod> {
  final PageController _pageController= PageController(viewportFraction: 0.6);
 double currentPage =0.0;
 bool isPlaying=false;
  String filePath;
 AudioPlayer _audioPlayer = AudioPlayer();
 void chooseFile()async{
   String filePath = await FilePicker.getFilePath();

   _audioPlayer.play(filePath,isLocal:true);
   setState(() {
     isPlaying=true;
   });

 }
 
  @override
  void initState() {
    // TODO: implement initState
    _pageController.addListener(() { setState(() {
      currentPage= _pageController.page;
    });});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[ Container(
              height: 350,
              color: Colors.black87,
              child: PageView.builder(
              scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: 9,
                itemBuilder: (context,int currentIndx){
                return AlbumCard(color:Colors.white,currentIndx:currentIndx,currentPage:currentPage);
                },
              )
                  
            ),
                   Spacer(),

                   Center(
                    child: Container(
                      height: 400,
                      width: 400,
                      child: Stack(

                         alignment: Alignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onPanUpdate: null,

                          ),
                       Container(

                         height: 350,
                         width: 350,
                         decoration: BoxDecoration(
                           color: Colors.black87,
                           shape: BoxShape.circle,
                         ),),
                          Positioned(
                            left:60,
                            child: IconButton(
                              icon:Icon(Icons.fast_rewind,color:Colors.white),
                              iconSize: 50,
                              onPressed: () {
                                if (_pageController.hasClients) {
                                  _pageController.animateToPage(
                                    (currentPage-1).toInt(),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,);
                                }
                              }
                            ),
                          ),
                          Positioned(
                            right: 60,
                            child: IconButton(
                              icon:Icon(Icons.fast_forward,color:Colors.white,size: 60,),
                              iconSize: 50,
                              onPressed: (){
                                if (_pageController.hasClients) {
                                  _pageController.animateToPage(
                                    (currentPage+1).toInt(),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 60,
                            child: IconButton(
                              icon :Icon(Icons.play_arrow,color:Colors.white,size: 60,),
                              iconSize: 50,
                              onPressed: (){
                               if (isPlaying){
                                 _audioPlayer.pause();
                                 setState(() {
                                   isPlaying=false;
                                 });
                               }else{
                                 _audioPlayer.play(filePath);
                                 setState(() {
                                   isPlaying=true;
                                 });
                               }
                              }
                            ),
                          ),
                          Positioned(
                            top: 60,
                            child: RaisedButton(
                              color: Colors.transparent,
                              child: Text('MENU',style: TextStyle(color: Colors.white,fontSize: 20),),
                             onPressed: (){
                                chooseFile();
                             }
                            )
                          ),
                          Container(

                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              shape: BoxShape.circle,
                            ),),
                        /*  IconButton(
                            icon: Icon(Icons.fast_rewind),
                          ),
                          IconButton(
                            icon: Icon(Icons.fast_rewind),
                          ),*/
                        ],

                      ),
                    ),
                  ),
                

          ]),
        ),

    );
  }
}
class AlbumCard extends StatelessWidget {
  final Color color;
  final int currentIndx;
  final double currentPage;
  AlbumCard({this.color,this.currentPage,this.currentIndx, });
  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIndx-currentPage;
    return Container(
      width: 200,

      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.005)
          ..scale((1-relativePosition.abs()).clamp(.2, .6)+.4)
          ..rotateY( relativePosition),
        alignment: relativePosition>=0? Alignment.centerLeft:Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 45, 10, 45),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,

          ),

        ),
      ),
    );
  }
}
